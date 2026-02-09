#
# This file is part of the Actors.jl Julia package, 
# MIT license, part of https://github.com/JuliaActors
#

const date_format = "yyyy-mm-dd HH:MM:SS"

tid(t::Task=current_task()) = convert(UInt, pointer_from_objref(t))
pqtid(t::Task=current_task()) = uint2quint(tid(t), short=true)
function id()
    return try
        act = task_local_storage("_ACT")
        isnothing(act.name) ? pqtid() : String(act.name)
    catch
        pqtid()
    end
end

function log_warn(msg::Down, info::String="")
    log_warn(msg.reason isa Exception ?
            "Down: $info $(msg.task), $(msg.task.exception)" :
            "Down: $info $(msg.reason)")
end
function log_warn(msg::Exit, info::String="")
    log_warn(msg.reason isa Exception && !isnothing(msg.task.exception) ?
            "Exit: $info $(msg.task), $(msg.task.exception)" :
            "Exit: $info $(msg.reason)")
end
function log_warn(s::String)
    @warn "$(Dates.format(now(), date_format)) $(id()) $s"
end

function log_error(s::String, ex::Exception, bt=nothing)
    exc = isnothing(bt) ? ex : (ex,bt)
    @error "$(Dates.format(now(), date_format)) $(id()) $s" exception=exc
end
