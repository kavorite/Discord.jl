"""
A Discord user.
More details [here](https://discordapp.com/developers/docs/resources/user#user-object).
"""
@from_dict struct User
    id::Snowflake
    # TODO: There's one case where everything but id is missing.
    # Find it in the docs and refer to it here.
    username::Union{String, Missing}
    discriminator::Union{String, Missing}
    avatar::Union{String, Nothing, Missing}
    bot::Union{Bool, Missing}
    mfa_enabled::Union{Bool, Missing}
    locale::Union{String, Missing}
    verified::Union{Bool, Missing}
    email::Union{String, Missing}
    member::Union{Dict, Missing}  # It's a GuildMember, but we haven't defined that yet.
end