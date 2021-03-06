export Guild

"""
A [`Guild`](@ref)'s verification level.
More details [here](https://discordapp.com/developers/docs/resources/guild#guild-object-verification-level).
"""
@enum VerificationLevel VL_NONE VL_LOW VL_MEDIUM VL_HIGH VL_VERY_HIGH
@boilerplate VerificationLevel :export :lower

"""
A [`Guild`](@ref)'s default message notification level.
More details [here](https://discordapp.com/developers/docs/resources/guild#guild-object-default-message-notification-level).
"""
@enum MessageNotificationLevel MNL_ALL_MESSAGES MNL_ONLY_MENTIONS
@boilerplate MessageNotificationLevel :export :lower

"""
A [`Guild`](@ref)'s explicit content filter level.
More details [here](https://discordapp.com/developers/docs/resources/guild#guild-object-explicit-content-filter-level).
"""
@enum ExplicitContentFilterLevel ECFL_DISABLED ECFL_MEMBERS_WITHOUT_ROLES ECFL_ALL_MEMBERS
@boilerplate ExplicitContentFilterLevel :export :lower

"""
A [`Guild`](@ref)'s MFA level.
More details [here](https://discordapp.com/developers/docs/resources/guild#guild-object-mfa-level).
"""
@enum MFALevel ML_NONE ML_ELEVATED
@boilerplate MFALevel :export :lower

"""
A Discord guild (server).
Can either be an [`UnavailableGuild`](@ref) or a [`Guild`](@ref).
"""
abstract type AbstractGuild end
function AbstractGuild(; kwargs...)
    return if get(kwargs, :unavailable, length(kwargs) <= 2) === true
        UnavailableGuild(; kwargs...)
    else
        Guild(; kwargs...)
    end
end
AbstractGuild(d::Dict{Symbol, Any}) = AbstractGuild(; d...)
mock(::Type{AbstractGuild}) = mock(rand(Bool) ? UnavailableGuild : Guild)

"""
An unavailable Discord guild (server).
More details [here](https://discordapp.com/developers/docs/resources/guild#unavailable-guild-object).
"""
struct UnavailableGuild <: AbstractGuild
    id::Snowflake
    unavailable::Union{Bool, Missing}
end
@boilerplate UnavailableGuild :constructors :docs :lower :merge :mock

"""
A Discord guild (server).
More details [here](https://discordapp.com/developers/docs/resources/guild#guild-object).
"""
struct Guild <: AbstractGuild
    id::Snowflake
    name::String
    icon::Union{String, Nothing}
    splash::Union{String, Nothing}
    owner::Union{Bool, Missing}
    owner_id::Union{Snowflake, Missing}  # Missing in Invite.
    permissions::Union{Int, Missing}
    region::Union{String, Missing}  # Invite
    afk_channel_id::Union{Snowflake, Missing, Nothing}  # Invite
    afk_timeout::Union{Int, Missing}  # Invite
    embed_enabled::Union{Bool, Missing}
    embed_channel_id::Union{Snowflake, Missing, Nothing}  # Not supposed to be nullable.
    verification_level::VerificationLevel
    default_message_notifications::Union{MessageNotificationLevel, Missing}  # Invite
    explicit_content_filter::Union{ExplicitContentFilterLevel, Missing}  # Invite
    roles::Union{Vector{Role}, Missing}  # Invite
    emojis::Union{Vector{Emoji}, Missing}  # Invite
    features::Vector{String}
    mfa_level::Union{MFALevel, Missing}  # Invite
    application_id::Union{Snowflake, Missing, Nothing}  # Invite
    widget_enabled::Union{Bool, Missing}
    widget_channel_id::Union{Snowflake, Missing, Nothing}  # Not supposed to be nullable.
    system_channel_id::Union{Snowflake, Missing, Nothing}  # Invite
    joined_at::Union{DateTime, Missing}
    large::Union{Bool, Missing}
    unavailable::Union{Bool, Missing}
    member_count::Union{Int, Missing}
    voice_states::Union{Vector{VoiceState}, Missing}
    members::Union{Vector{Member}, Missing}
    channels::Union{Vector{DiscordChannel}, Missing}
    presences::Union{Vector{Presence}, Missing}
    djl_users::Union{Set{Snowflake}, Missing}
    djl_channels::Union{Set{Snowflake}, Missing}
end
@boilerplate Guild :constructors :docs :lower :merge :mock

Base.merge(x::UnavailableGuild, y::Guild) = y
Base.merge(x::Guild, y::UnavailableGuild) = x
