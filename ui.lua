SMODS.current_mod.description_loc_vars = function(self)
    return {
        text_colour = G.C.WHITE,
        background_colour = HEX("00000000"),
        scale = 1.1
    }
end

SMODS.Atlas {
    key = "milky_credits",
    px = 1656,
    py = 647,
    path = "logo_credit.png"
}

SMODS.Joker {
    key = "config_credits",
    atlas = "milky_credits",
    pos = {x = 0, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = true,
    loc_txt = {
        name = "",
        text = {
            ""
        }
    },
    in_pool = function(self, args)
        return false
    end
}

SMODS.current_mod.custom_ui = function(mod_nodes)
    G.mktjk_logo_cardarea = CardArea(G.ROOM.T.x / 2, G.ROOM.T.y / 2, G.CARD_W, G.CARD_H, {type = "title", card_limit = 1})
    local logo_card = Card(G.mktjk_logo_cardarea.T.x, G.mktjk_logo_cardarea.T.x, G.CARD_W * 1.39 * 2.2, G.CARD_H * 0.4 * 2.2, G.P_CENTERS.j_mktjk_config_credits, G.P_CENTERS.j_mktjk_config_credits)
    logo_card.no_ui = true
    G.mktjk_logo_cardarea:emplace(logo_card)
    table.insert(mod_nodes, 2, {
        n = G.UIT.R,
        config = {align = "cm"},
        nodes = {
            {
                n = G.UIT.C,
                config = {align = "cm"},
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = G.mktjk_logo_cardarea
                        }
                    }
                }
            }
        }
    })
    table.insert(mod_nodes, {
        n = G.UIT.R,
        config = {align = "cm"},
        nodes = {
            {
                n = G.UIT.C,
                config = {align = "cm"},
                nodes = {
                    UIBox_button({
                        button = "mktjk_website",
                        label = {localize("b_mktjk_website")},
                        minw = 6
                    })
                }
            }
        }
    })
end

local XmainMenuHook = Game.main_menu
function Game:main_menu(ctx)
    local r = XmainMenuHook(self,ctx)
    if self.title_top then
        local tg = self.title_top
        local card = Card(tg.T.x,tg.T.y,G.CARD_W,G.CARD_H,nil,G.P_CENTERS['j_mktjk_milky'])
        card.bypass_discovery_center = true
        card.T.w = card.T.w * 1.35
        card.T.h = card.T.h * 1.35
        
        G.title_top.T.w = G.title_top.T.w + 1.35
        G.title_top.T.x = G.title_top.T.x - 0.7
        card:set_sprites(card.config.center)
        card.no_ui = true
        card.states.visible = false
        self.title_top:emplace(card)
        self.title_top:align_cards()
        G.E_MANAGER:add_event(
            Event{
                delay = 0.5,
                func = function ()
                    if ctx == "splash" then
                        card.states.visible = true
                        card:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 0.5)
                    else
                        card.states.visible = true
                        card:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 0.2)
                    end
                    return true
                end
            }
        )
    end

    return r
end

function G.FUNCS.mktjk_website()
    love.system.openURL("https://milkyway.moe")
end

-- Credits Tab - Derived from Joyous Spring credits tab
SMODS.current_mod.extra_tabs = function()
    return {
        {
            label = localize('b_mktjk_credits'),
            tab_definition_function = function()
                local modNodes = {}
                modNodes[#modNodes + 1] = {}
                local loc_vars = { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.4 }
                localize { type = 'descriptions', key = 'mktjk_credits', set = 'Other', nodes = modNodes[#modNodes], vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour, shadow = loc_vars.shadow }
                modNodes[#modNodes] = desc_from_rows(modNodes[#modNodes])
                modNodes[#modNodes].config.colour = loc_vars.background_colour or modNodes[#modNodes].config.colour

                return {
                    n = G.UIT.ROOT,
                    config = {
                        emboss = 0.05,
                        minh = 6,
                        r = 0.1,
                        minw = 6,
                        align = "tm",
                        padding = 0.2,
                        colour = G.C.BLACK
                    },
                    nodes = modNodes
                }
            end
        }
    }
end
