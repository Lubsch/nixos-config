const std = @import("std");

pub fn main() !void {
    const home_path = std.posix.getenv("HOME").?;
    const home = try std.fs.openDirAbsolute(home_path, .{ .no_follow = true });

    var args = std.process.args();
    _ = args.next(); // discard program path

    // ensure trailing / (without using allocations)
    var new_gen_path = args.next().?;
    if (new_gen_path[new_gen_path.len - 1] != '/') {
        var buffer: [1024]u8 = undefined;
        @memcpy(&buffer, new_gen_path.ptr);
        buffer[new_gen_path.len] = '/';
        buffer[new_gen_path.len + 1] = 0;
        new_gen_path = buffer[0 .. new_gen_path.len + 1 :0];
    }

    while (args.next()) |source_path| {
        var it = std.mem.splitSequence(u8, source_path, new_gen_path);
        _ = it.next();
        const relative_path = it.next().?;

        // file exists -> delete it
        // if (home.access(relative_path, .{})) |_| {
        //     try home.deleteFile(relative_path) catch ;
        // } else |err| {
        //     std.debug.print("err: {any}\n", .{err});
        // }

        // just delete it
        home.deleteFile(relative_path) catch {};

        // create parents
        if (std.fs.path.dirname(relative_path)) |parent_dir| {
            try home.makePath(parent_dir);
        }

        // create symlink
        std.debug.print("new_gen_path: {s}\nsource_path: {s}\nrelative_path: {s}\n", .{ new_gen_path, source_path, relative_path });
        try home.symLink(source_path, relative_path, .{});
    }
}
