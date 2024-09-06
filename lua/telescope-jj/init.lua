local conflicts = require("telescope-jj.conflicts")
local diff = require("telescope-jj.diff")
local files = require("telescope-jj.files")
local branches = require("telescope-jj.branches")

return {
    conflicts = conflicts,
    diff = diff,
    files = files,
    branches = branches,
}
