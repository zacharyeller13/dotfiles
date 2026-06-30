---@class Space
---@field workspace string
---@field monitor-id integer
---@field workspace-is-visible boolean

---@class Window
---@field app_name string
---@field bundle_id string
---@field frame table<string, any>
---@field id {idx: integer, pid: integer}
---@field is_floating boolean
---@field is_focused boolean
---@field title string
---@field window_server_id integer

---@class RiftSpace
---@field id string
---@field index integer
---@field is_active boolean
---@field layout_mode string
---@field name string
---@field window_count integer
---@field windows Window[]

---@alias uuid string

---@class Display
---@field active_space_ids integer[]
---@field frame table<string, any>
---@field inactive_space_ids integer[]
---@field is_active_context boolean
---@field is_active_space boolean
---@field name string
---@field screen_id integer
---@field space integer
---@field uuid uuid

---{"type":"workspace_changed","space_id":1,"workspace_id":{"idx":2,"version":1},"workspace_name":"second","display_uuid":"37D8832A-2D66-02CA-B9F7-8F30A301B230"}
---@class WorkspaceChangedEvent
---@field type "workspace_changed"
---@field space_id integer
---@field workspace_id {idx: integer, version: integer}
---@field workspace_name string
---@field display_uuid uuid
