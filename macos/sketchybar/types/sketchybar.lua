---@meta

---@alias SbarPrimitive string|number|boolean
---@alias SbarTable table<string, SbarValue>
---@alias SbarValue SbarPrimitive|SbarTable

---@class SbarEnv
---@field NAME? string
---@field SENDER? string
---@field INFO? any
---@field BUTTON? string
---@field SID? string
---@field SELECTED? string|boolean
---@field PERCENTAGE? string|number
---@field [string] any

---@alias SbarEvent string|string[]
---@alias SbarSubscribeCallback fun(env: SbarEnv)
---@alias SbarExecCallback fun(result: any, exit_code: integer)
---@alias SbarNoArgCallback fun()

---@class SbarItem
---@field name string
---@field set fun(self: SbarItem, props: SbarTable)
---@field subscribe fun(self: SbarItem, events: SbarEvent, cb: SbarSubscribeCallback)
---@field query fun(self: SbarItem): table<string, any>|nil
---@field push fun(self: SbarItem, values: number[])

---@alias SbarTarget string|SbarItem

---@class Sbar
local sbar = {}

---@overload fun(kind: 'item'|'space'|'alias', props: SbarTable): SbarItem
---@overload fun(kind: 'item'|'space'|'alias', name: string, props?: SbarTable): SbarItem
---@overload fun(kind: 'bracket', members: string[], props?: SbarTable): SbarItem
---@overload fun(kind: 'bracket', name: string, members: string[], props?: SbarTable): SbarItem
---@overload fun(kind: 'slider', width: number, props?: SbarTable): SbarItem
---@overload fun(kind: 'slider', name: string, width: number, props?: SbarTable): SbarItem
---@overload fun(kind: 'graph', width: number, props: SbarTable): SbarItem
---@overload fun(kind: 'graph', name: string, width: number, props: SbarTable): SbarItem
---@overload fun(kind: 'event', name: string): SbarItem
---@overload fun(kind: 'event', name: string, ns_notification: string): SbarItem
---@overload fun(kind: 'event', name: string, ns_notification: string, props: SbarTable): SbarItem
---@param kind string
---@param a any
---@param b? any
---@param c? any
---@return SbarItem
function sbar.add(kind, a, b, c) end

---@param target SbarTarget
---@param props SbarTable
function sbar.set(target, props) end

---@param props SbarTable
function sbar.bar(props) end

---@param props SbarTable
function sbar.default(props) end

---@param target SbarTarget
function sbar.remove(target) end

---@param name string
---@param direction string
---@param location string
function sbar.move(name, direction, location) end

---@param target SbarTarget
---@param events SbarEvent
---@param cb SbarSubscribeCallback
function sbar.subscribe(target, events, cb) end

---@param target SbarTarget
---@return table<string, any>|nil
function sbar.query(target) end

---@param target SbarTarget
---@param values number[]
function sbar.push(target, values) end

---@param event string
---@param env? SbarTable
function sbar.trigger(event, env) end

---@param curve string
---@param duration number
---@param cb SbarNoArgCallback
function sbar.animate(curve, duration, cb) end

---@param command string
---@param cb? SbarExecCallback
function sbar.exec(command, cb) end

---@param seconds number
---@param cb SbarNoArgCallback
function sbar.delay(seconds, cb) end

---@param enabled boolean
function sbar.hotload(enabled) end

---@param name string
function sbar.set_bar_name(name) end

function sbar.begin_config() end
function sbar.end_config() end

function sbar.update() end
function sbar.event_loop() end

return sbar
