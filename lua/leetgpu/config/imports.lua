---@type table<string, string[]>
local imports = {
    cuda = {
        "#include <cuda_runtime.h>",
        "#include <stdio.h>",
    },
    cpp = {
        "#include <iostream>",
        "#include <vector>",
    },
    c = {
        "#include <stdio.h>",
        "#include <stdlib.h>",
    },
    python = {},
    python3 = {},
}

return imports
