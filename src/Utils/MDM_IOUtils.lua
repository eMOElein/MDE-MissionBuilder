MDM_IOUtils = {}

function MDM_IOUtils.ReadDirectory(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen( 'dir "'..directory..'" /b /a')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end
