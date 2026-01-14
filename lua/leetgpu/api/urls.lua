---@class lg.api.urls
local urls = {}

-- LeetGPU.com API endpoints
urls.base = "https://leetgpu.com"
urls.challenges = "/api/challenges/"
urls.challenge = "/api/challenges/%s/"
urls.submit = "/api/challenges/%s/submit/"
urls.run = "/api/challenges/%s/run/"
urls.check = "/api/submissions/%s/"
urls.leaderboard = "/api/leaderboard/"

return urls
