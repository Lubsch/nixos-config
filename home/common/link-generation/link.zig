const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var env_map = try std.process.getEnvMap(allocator);
    defer env_map.deinit();

    const home_path = env_map.get("HOME").?;
    const home = try std.fs.openDirAbsolute(home_path, .{ .no_follow = true });

    var args = std.process.args();
    _ = args.next(); // discard program path

    const new_gen_path = args.next().?;
    while (args.next()) |source_path| {
        const relative_path = try std.fs.path.relative(allocator, new_gen_path, source_path);

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
        // std.debug.print("source_path: {s}\nrelative_path: {s}\n", .{ source_path, relative_path });
        try home.symLink(source_path, relative_path, .{});
    }
}

