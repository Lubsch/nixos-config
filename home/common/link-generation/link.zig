const std = @import("std");

const path_max = 4096;

pub fn main() !void {
    const home_path = std.posix.getenv("HOME").?;
    const home = try std.fs.openDirAbsolute(home_path, .{});

    var args = std.process.args();
    _ = args.next(); // discard program path

    // ensure trailing / (without using allocations)
    var new_gen_path = args.next().?;
    if (new_gen_path[new_gen_path.len - 1] != '/') {
        var buf = std.mem.zeroes([path_max]u8);
        @memcpy(&buf, new_gen_path.ptr);
        buf[new_gen_path.len] = '/';
        buf[new_gen_path.len + 1] = 0;
        new_gen_path = buf[0 .. new_gen_path.len + 1 :0];
    }

    while (args.next()) |source_path| {
        var it = std.mem.splitSequence(u8, source_path, new_gen_path);
        _ = it.next();
        const relative_path = it.next().?;

        // create parents
        // can fail if file is in new_gen_path
        if (std.fs.path.dirname(relative_path)) |parent_dir| {
            try home.makePath(parent_dir);
        }

        var buf = std.mem.zeroes([path_max]u8);
        if (home.readLink(relative_path, &buf)) |target_path| {
            if (std.mem.eql(u8, target_path, source_path)) {
                // we don't need to do anything
                return;
            }
        } else |_| {}

        home.deleteFile(relative_path) catch {};

        // create symlink
        // std.debug.print("new_gen_path: {s}\nsource_path: {s}\nrelative_path: {s}\n", .{ new_gen_path, source_path, relative_path });
        try home.symLink(source_path, relative_path, .{});
    }
}
