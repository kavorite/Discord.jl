export Activity

"""
An [`Activity`](@ref)'s type. Available values are `AT_GAME`, `AT_STREAMING`,
`AT_LISTENING`, and `AT_WATCHING`.
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object-activity-types).
"""
@enum ActivityType AT_GAME AT_STREAMING AT_LISTENING AT_WATCHING
@boilerplate ActivityType :export :lower

"""
Flags which indicate what an [`Activity`](@ref) payload contains.
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object-activity-flags).
"""
@enum ActivityFlags begin
    AF_INSTANCE=1<<0
    AF_JOIN=1<<1
    AF_SPECTATE=1<<2
    AF_JOIN_REQUEST=1<<3
    AF_SYNC=1<<4
    AF_PLAY=1<<5
end
@boilerplate ActivityFlags :export :lower

"""
The start and stop times of an [`Activity`](@ref).
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object-activity-timestamps).
"""
struct ActivityTimestamps
    start::Union{DateTime, Missing}
    stop::Union{DateTime, Missing}
end
@boilerplate ActivityTimestamps :constructors :docs :lower :merge :mock

"""
The current party of an [`Activity`](@ref)'s player.
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object-activity-party).
"""
struct ActivityParty
    id::Union{String, Missing}
    size::Union{Vector{Int}, Missing}
end
@boilerplate ActivityParty :constructors :docs :lower :merge :mock

"""
Images and hover text for an [`Activity`](@ref).
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object-activity-assets).
"""
struct ActivityAssets
    large_image::Union{String, Missing}
    large_text::Union{String, Missing}
    small_image::Union{String, Missing}
    small_text::Union{String, Missing}
end
@boilerplate ActivityAssets :constructors :docs :lower :merge :mock

"""
Secrets for Rich Presence joining and spectating of an [`Activity`](@ref).
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object-activity-secrets).
"""
struct ActivitySecrets
    join::Union{String, Missing}
    spectate::Union{String, Missing}
    match::Union{String, Missing}
end
@boilerplate ActivitySecrets :constructors :docs :lower :merge :mock

"""
A [`User`](@ref) activity.
More details [here](https://discordapp.com/developers/docs/topics/gateway#activity-object).
"""
struct Activity
    name::String
    type::ActivityType
    url::Union{String, Nothing, Missing}
    timestamps::Union{ActivityTimestamps, Missing}
    application_id::Union{Snowflake, Missing}
    details::Union{String, Nothing, Missing}
    state::Union{String, Nothing, Missing}
    party::Union{ActivityParty, Missing}
    assets::Union{ActivityAssets, Missing}
    secrets::Union{ActivitySecrets, Missing}
    instance::Union{Bool, Missing}
    flags::Union{Int, Missing}
end
@boilerplate Activity :constructors :docs :lower :merge :mock
