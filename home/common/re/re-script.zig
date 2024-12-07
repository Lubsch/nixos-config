const std = @import("std");

// TODO consider handling command errors
pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    try std.process.changeCurDir("/home/lubsch/misc/repos/nixos-config");

    // run git commands to get all changed files in repo
    var files_iter = blk: {
        var git_ls = std.process.Child.init(&[_][]const u8{ "git", "ls-files", "--deleted", "--others", "--modified", "--exclude-standard" }, allocator);
        var git_diff = std.process.Child.init(&[_][]const u8{ "git", "diff", "--name-only", "--staged" }, allocator);

        git_ls.stdout_behavior = .Pipe;
        git_ls.stderr_behavior = .Pipe;
        git_diff.stdout_behavior = .Pipe;
        git_diff.stderr_behavior = .Pipe;

        var stdout = std.ArrayList(u8).init(allocator);
        var stdout2 = std.ArrayList(u8).init(allocator);
        var stderr = std.ArrayList(u8).init(allocator); // we basically ignore stderr

        try git_ls.spawn();
        try git_diff.spawn();
        try git_ls.collectOutput(&stdout, &stderr, 10000);
        try git_diff.collectOutput(&stdout2, &stderr, 10000);
        try stdout.appendSlice(stdout2.items);
        break :blk std.mem.splitScalar(u8, stdout.items[0..stdout.items.len], '\n');
    };

    var files = std.ArrayList([]const u8).init(allocator);

    // filter to nix files
    var nix_files = std.ArrayList([]const u8).init(allocator);
    while (files_iter.next()) |file| {
        if (file.len == 0) {
            break;
        }
        try files.append(file);
        if (std.mem.eql(u8, ".nix", file[file.len -| 4..])) {
            try nix_files.append(file);
        }
    }

    // std.debug.print("Nix files:\n", .{});
    // for (nix_files.items) |file| {
    //     std.debug.print("{s}\n", .{file});
    // }

    // std.debug.print("All files:\n", .{});
    // for (files.items) |file| {
    //     std.debug.print("{s}\n", .{file});
    // }

    // only run nixfmt if nix files have changed
    if (nix_files.items.len > 0) {
        var nixfmt_args = std.ArrayList([]const u8).init(allocator);
        try nixfmt_args.append("nixfmt");
        try nixfmt_args.appendSlice(nix_files.items);

        var nixfmt = std.process.Child.init(nixfmt_args.items, allocator);
        _ = try nixfmt.spawnAndWait();
    }

    // avoid work if nothing's changed at all
    if (files.items.len > 0) {
        var git_add_args = std.ArrayList([]const u8).init(allocator);
        try git_add_args.append("git");
        try git_add_args.append("add");
        try git_add_args.appendSlice(files.items);
        var git_add = std.process.Child.init(git_add_args.items, allocator);
        _ = try git_add.spawnAndWait();

        var rebuild = std.process.Child.init(&[_][]const u8{ "sudo", "nixos-rebuild-ng", "switch", "--flake", "." }, allocator);
        _ = try rebuild.spawnAndWait();

        // git commit and push if you are child
        if (try std.posix.fork() == 0) {
            var git_commit = std.process.Child.init(&[_][]const u8{ "git", "commit", "--allow-empty-message", "-m", "" }, allocator);
            git_commit.stdout_behavior = .Ignore;
            git_commit.stderr_behavior = .Ignore;
            _ = try git_commit.spawnAndWait();
            var git_push = std.process.Child.init(&[_][]const u8{ "git", "push" }, allocator);
            git_push.stdout_behavior = .Ignore;
            git_push.stderr_behavior = .Ignore;
            _ = try git_push.spawnAndWait(); // there's nothing wrong with waiting so we don't orphan a process
        }
    } else {
        std.debug.print("Nothing to do!\n", .{});
    }
}
