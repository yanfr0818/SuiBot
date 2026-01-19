// Emoji mappings for gifts
export const EMOJI_MAP: Record<string, string> = {
    小花花: '🌸',
    牛哇牛哇: '🐮',
    打call: '📣',
    爱你: '❤️',
    B坷垃: '🎉',
    礼花: '🎆',
    棒棒哒: '👍',
    小心心: '💗',
    辣条: '🌶️',
    喵娘: '🐱',
    节奏风暴: '⚡',
    '666': '6️⃣',
}

// Guard type dictionary
export const GUARD_TYPE_DICT: Record<number, string> = {
    1: '总督🛡️',
    2: '提督🛡️',
    3: '舰长🛡️',
}

// Price tier emojis for gifts
export const PRICE_TIER_EMOJI = (price: number): string => {
    if (price >= 1000) return '💎' // 1000+ CNY
    if (price >= 500) return '💰' // 500+ CNY
    if (price >= 100) return '🎁' // 100+ CNY
    if (price >= 50) return '🎀' // 50+ CNY
    return '' // Below 50 CNY
}

// Superchat tier emojis
export const SUPERCHAT_TIER_EMOJI = (price: number): string => {
    if (price >= 2000) return '🔴' // Red (2000+ CNY)
    if (price >= 1000) return '🟠' // Orange (1000+ CNY)
    if (price >= 500) return '🟡' // Yellow (500+ CNY)
    if (price >= 100) return '🟢' // Green (100+ CNY)
    if (price >= 50) return '🔵' // Blue (50+ CNY)
    return '⚪' // White (below 50 CNY)
}

// Mute type mapping
export const MUTE_BY_MAP = (muteBy: number): string => {
    switch (muteBy) {
        case 1:
            return '房管'
        case 2:
            return '主播'
        default:
            return '系统'
    }
}
