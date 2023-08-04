local envMap = require("env").load()

for n in pairs(envMap) do
  print(n .." / ".. " env: " .. os.getenv(n) .. ", .env: ".. envMap[n])
end

