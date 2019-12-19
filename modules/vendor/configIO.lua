-- This module handle 'configIO' metadata generation for Exosense applications
-- Define here the device data schema as describe in https://github.com/exosite/industrial_iot_schema
-- Limitation: Exosense currently cannot modify per device schema
--
-- This file is in the 'vendor' safeNamespace and changes will persists upon template updates

local config_io = [[
{
  "last_edited": "2019-12-03",
  "meta": "Dragino LT-33222",
  "channels": {
    "001": {
      "display_name": "ACI1",
      "description": "Current Input 1",
      "properties": {
        "data_type": "ELEC_CURRENT",
        "primitive_type": "NUMERIC",
        "data_unit": "A",
        "precision": 2
      }
    },
    "002": {
      "display_name": "ACI2",
      "description": "Current Input 2",
      "properties": {
        "data_type": "ELEC_CURRENT",
        "primitive_type": "NUMERIC",
        "data_unit": "A",
        "precision": 2
      }
    },
    "003": {
      "display_name": "AVI1",
      "description": "Voltage Input 1",
      "properties": {
        "data_type": "ELEC_POTENTIAL",
        "primitive_type": "NUMERIC",
        "data_unit": "V",
        "precision": 2
      }
    },
    "004": {
      "display_name": "AVI2",
      "description": "Voltage Input 2",
      "properties": {
        "data_type": "ELEC_POTENTIAL",
        "primitive_type": "NUMERIC",
        "data_unit": "V",
        "precision": 2
      }
    },
    "005": {
      "display_name": "ROI1",
      "description": "Relay 1: 0=Open",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "006": {
      "display_name": "ROI2",
      "description": "Relay 2: 0=Open",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "007": {
      "display_name": "DI3",
      "description": "Digital Input 3",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "008": {
      "display_name": "DI2",
      "description": "Digital Input 2",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "009": {
      "display_name": "DI1",
      "description": "Digital Input 1",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "010": {
      "display_name": "DO3",
      "description": "Digital Output 3",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "011": {
      "display_name": "DO2",
      "description": "Digital Output 2",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    },
    "012": {
      "display_name": "DO1",
      "description": "Digital Output 1",
      "properties": {
        "data_type": "BOOLEAN",
        "primitive_type": "BOOLEAN"
      }
    }
  }
}
]]

return {
  set_to_device = true, -- If set to true, the config_io will be saved & duplicated in each device state
  -- This enables to define a different data schema per device.
  -- By default (false) the above config IO is injected on the fly to the application
  timestamp = 1563939215, -- Unix timestamp of this schema version update
  config_io = config_io
}
