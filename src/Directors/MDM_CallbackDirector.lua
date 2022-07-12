MDM_CallbackDirector = {}

function MDM_CallbackDirector:new (args)
  if not args.callback then
    error("callback not set",2)
  end

  if type(args.callback) ~= "function" then
    error("provided callback is no function",2)
  end

  local director = MDM_Director:new(args)
  director.callback = args.callback

  director:OnUpdate(function() MDM_CallbackDirector._OnUpdate(director) end)


  return director
end

function MDM_CallbackDirector._OnUpdate(self)
  self.callback()
end
