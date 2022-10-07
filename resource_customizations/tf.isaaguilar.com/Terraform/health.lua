function getStatusBasedOnPhase(obj)
    hs = {}
    hs.status = "Progressing"
    hs.message = "Waiting for Terraform"
    if obj.status ~= nil and obj.status.phase ~= nil then
        if obj.status.phase == "completed" then
            hs.status = "Healthy"
            hs.message = "Terraform is done"
        end
    end
    return hs
end

function getReadyContitionMessage(obj)
    if obj.status ~= nil and obj.status.stages ~= nil then
        for i, stage in ipairs(obj.status.stages) do
        if stage.generation == obj.metadata.generation then
          if stage.state ~= "complete" then
              return stage.reason
          end
        end
        end
    end
    return "Condition is unknown"
end

hs = getStatusBasedOnPhase(obj)
if hs.status ~= "Healthy" then
    hs.message = getReadyContitionMessage(obj)
end

return hs
