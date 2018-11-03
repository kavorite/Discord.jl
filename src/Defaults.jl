module Defaults

export handler

using Discord
using Discord: insert_or_update!, locked
using Setfield
using TimeToLive

function handler(c::Client, e::Ready)
    c.state.v = e.v
    c.state.session_id = e.session_id
    c.state._trace = e._trace
    c.state.user = e.user

    for ch in e.private_channels
        put!(c.state, ch)
    end
    for g in e.guilds
        # Don't use put! normally here because these guilds are unavailable.
        if !haskey(c.state.guilds, g.id)
            c.state.guilds[g.id] = g
        end
    end
end

handler(c::Client, e::Resumed) = c.state._trace = e._trace
handler(c::Client, e::Union{ChannelCreate, ChannelUpdate}) = put!(c.state, e.channel)
handler(c::Client, e::ChannelDelete) = delete!(c.state.channels, e.channel.id)
handler(c::Client, e::Union{GuildCreate, GuildUpdate}) = put!(c.state, e.guild)
handler(c::Client, e::GuildEmojisUpdate) = put!(c.state, e.emojis; guild=e.guild_id)
handler(c::Client, e::GuildMemberAdd) = put!(c.state, e.member; guild=e.guild_id)
handler(c::Client, e::Union{MessageCreate, MessageUpdate}) = put!(c.state, e.message)
handler(c::Client, e::MessageDelete) = delete!(c.state.messages, e.id)
handler(c::Client, e::PresenceUpdate) = put!(c.state, e.presence)

function handler(c::Client, e::GuildDelete)
    delete!(c.state.guilds, e.id)
    delete!(c.state.members, e.id)
    delete!(c.state.presences, e.id)
end

function handler(c::Client, e::GuildMemberUpdate)
    haskey(c.state.members, e.guild_id) || return
    haskey(c.state.members[e.guild_id], e.user.id) || return

    ms = c.state.members[e.guild_id]
    m = ms[e.user.id]
    m = @set m.user = merge(m.user, e.user)
    m = @set m.nick = e.nick
    m = @set m.roles = e.roles

    put!(c.state, e.user)
end

function handler(c::Client, e::GuildMemberRemove)
    haskey(c.state.members, e.guild_id) || return
    ismissing(e.user) && return
    delete!(c.state.members[e.guild_id], e.user.id)
end

function handler(c::Client, e::GuildMembersChunk)
    for m in e.members
        put!(c.state, m; guild=e.guild_id)
    end
end

function handler(c::Client, e::Union{GuildRoleCreate, GuildRoleUpdate})
    put!(c.state, e.role; guild=e.guild_id)
end

function handler(c::Client, e::GuildRoleDelete)
    haskey(c.state.guilds, e.guild_id) || return
    isa(c.state.guilds[e.guild_id], Guild) || return
    rs = c.state.guilds[e.guild_id].roles
    ismissing(rs) && return

    idx = findfirst(r -> r.id == e.role_id, rs)
    idx === nothing || deleteat!(rs, idx)
end

function handler(c::Client, e::MessageDeleteBulk)
    for id in e.ids
        delete!(c.state.messages, id)
    end
end

function handler(c::Client, e::MessageReactionAdd)
    put!(c.state, e.emoji; message=e.message_id, user=e.user_id)
end

function handler(c::Client, e::MessageReactionRemove)
    locked(c.state.lock) do
        haskey(c.state.messages, e.message_id) || return
        ismissing(c.state.messages[e.message_id].reactions) && return

        rs = c.state.messages[e.message_id].reactions
        idx = findfirst(r -> r.emoji.name == e.emoji.name, rs)
        if idx !== nothing
            if rs[idx].count == 1
                deleteat!(rs, idx)
            else
                r = rs[idx]
                r = @set r.count -= 1
                r = @set r.me &= ismissing(c.state.user) || c.state.user.id != e.user_id
                rs[idx] = r
            end
        end
    end
    touch(c.state.messages, e.message_id)
end

function handler(c::Client, e::MessageReactionRemoveAll)
    haskey(c.state.messages, e.message_id) || return
    ismissing(c.state.messages[e.message_id].reactions) && return

    locked(c.state.lock) do
        empty!(c.state.messages[e.message_id].reactions)
    end
    touch(c.state.messages, e.message_id)
end

end
