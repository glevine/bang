def command?(name)
  `command -v #{name}`
  $?.success?
end
