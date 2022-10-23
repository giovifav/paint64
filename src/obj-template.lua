local template = Object:extend()

function template:new(r,g,b)
    template.super.new(self,r,g,b)
    print("template found")
end

function template:update()

end

return template
