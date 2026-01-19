import type { LaplaceEvent } from '@laplace.live/event-types'

/**
 * EventStore keeps track of recent events for context in notifications
 */
export class EventStore {
    private events: LaplaceEvent[] = []
    private readonly maxAge: number

    constructor(maxAgeMs = 6000) {
        this.maxAge = maxAgeMs
    }

    /**
     * Add an event to the store
     */
    addEvent(event: LaplaceEvent): void {
        this.events.push(event)
        this.cleanup()
    }

    /**
     * Get recent events (limited by count and age)
     */
    getRecentEvents(count: number): LaplaceEvent[] {
        this.cleanup()
        return this.events.slice(-count)
    }

    /**
     * Get events by specific user UID
     */
    getEventsByUid(uid: number, count: number): LaplaceEvent[] {
        this.cleanup()
        return this.events.filter((e) => e.uid === uid).slice(-count)
    }

    /**
     * Remove events older than maxAge
     */
    private cleanup(): void {
        const now = Date.now()
        this.events = this.events.filter(
            (e) => now - e.timestampNormalized < this.maxAge,
        )
    }
}

/**
 * Format messages for context display
 */
export function formatMessagesContext(events: LaplaceEvent[]): string {
    if (events.length === 0) return ''

    return events
        .filter((e) => e.type === 'message')
        .map((e) => {
            // @ts-expect-error - message type has these fields
            const username = e.username || 'Unknown'
            // @ts-expect-error - message type has these fields
            const message = e.message || ''
            return `${username}: ${message}`
        })
        .join('\\n')
}
