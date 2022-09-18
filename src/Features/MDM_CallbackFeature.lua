MDM_CallbackFeature = {}

function MDM_CallbackFeature:new (args)
  if not args.callback then
    error("callback not set",2)
  end

  if type(args.callback) ~= "function" then
    error("provided callback is no function",2)
  end

  local director = MDM_Feature:new(args)
  director.callback = args.callback
  
  director:OnUpdate(MDM_CallbackFeature._OnUpdate)

  return director
end

function MDM_CallbackFeature._OnUpdate(self)
  self.callback()
end
