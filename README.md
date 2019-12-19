
# Murano Cloud-Connector for The Things Network

This project is a template of a Murano IoT-Connector that interoperates with The Things Network. 
<br>
[High level user documentation](https://github.com/exosite/exosense_recipes/tree/master/TTN)<br>
[Detailed C2C Template information](https://github.com/exosite/getting-started-solution-template/tree/cloud2cloud-product)<br>

## Table of Contents

- [About This Project](#about-this-project)
- [Configure for Different LoRa Device](#configure-for-different-lora-device)
- [ToDo](#todo)
---

## About This Project

This is a Murano IoT Connector Template specifically configured for Cloud to Cloud communications with [The Things Network](https://www.thethingsnetwork.org/), and works out of the box with a [Dragino LT-33222-L LoRa I/O Controller](https://www.dragino.com/products/lora-lorawan-end-node/item/138-lt-33222-l.html).<br>
<br>
It is based on the [Getting Started Solution Template](https://github.com/exosite/getting-started-solution-template/tree/cloud2cloud-product) for Cloud to Cloud integrations.<br>
<br>
To use this project, first try following the [High level user guide](https://github.com/exosite/exosense_recipes/tree/master/TTN).  The instructions there will deploy a copy of this template into a Murano Solution in your business by using [the published Murano Exchange element](https://www.exosite.io/business/exchange/catalog/component/5dfb0070e1041e4cc6982817).  You can also fork this repository and create your own custom solution from your fork.<br>
<br>
Once this project has been instantiated inside of Murano as a solution, it:<br>
1.) receives TTN payloads on the callback URL (<your solution URL>/c2c/callback)<br>
2.) base64 decodes the payload<br>
3.) assembles parts of the payload into a data structure that [ExoSense](https://exosite.com/iot-solutions/condition-monitoring/) variants can natively use<br>
4.) cherry picks the "hardware_serial" value from the TTN payload and uses it as the unique device identifier in Murano<br>
5.) if a new device identifier is found, instantiates a new device and programs its "config_io" resource<br>
<br> 
Steps 1-4 are done in the [transform.lua module](./modules/vendor/c2c/transform.lua), and the config_io initialization (step 5) comes from the [configIO.lua module](./modules/vendor/configIO.lua).
<br>
If you have hardware other than the Dragino LT-33222-L LoRa I/O Controller, the code that does step 3 and step 5 will need to be modified (see next section).<br>
<br>
---

## Configure for Different LoRa device

To configure the project for a different LoRa device, modifications will be required to both the [transform.lua module](./modules/vendor/c2c/transform.lua), and the [configIO.lua module](./modules/vendor/configIO.lua).  These modifications can be done in Murano on the Modules subpage after deploying the [the published Murano Exchange element](https://www.exosite.io/business/exchange/catalog/component/5dfb0070e1041e4cc6982817), or you can fork/modify this project and deploy your own custom connector from your own Github URL.<br>
<br>
The payload for the LT-33222-L device is a 9 byte payload, so after converting the base64 value to a string, the LT-33222-L data sheet is used to pull the pertinent values back out as numbers.  Bytes 1,2 are ACI1; Bytes 3,4 are ACI2; Bytes 5,6 are AVI1; Bytes 7,8 are AVI2; and Byte 9 is a combination field representing digital I/O based on the bit field <RO1.RO2.DI3.DI2.DI1.DO3.DO2.DO1>.<br>
<br>
For your own device, determine how big the payload is and what parts of the payload belong to what sensor / data-channel, and modify the string parsing and array assignments to suite.<br>
<br>
The critical linkage between whatever data you parse out and ExoSense (or other app) data channels is the JSON array object identifiers must match the entries in configIO.lua.<br>
For example, the line that parses the ACI1 value:<br>
<code>data_in["001"] = tonumber(string.sub(payload,1,4),16) 		-- ACI1</code><br>
uses the object identifer "001".  This "001" links the data values to their meta data as defined in the configIO.lua file.<br>
<br>
Once you have the parsing working correctly for each "data channel", fill in the configIO.lua JSON array with the meta information for each channel based on the [Exosite Data Types article](https://github.com/exosite/industrial_iot_schema/blob/master/data-types.md).  This will allow ExoSense to auto-configure the different channels based on your settings.<br>
<br>
*NOTE:* If devices have already been spawned before you've been able to update the configIO.lua file, they will have gotten a copy of the old confiIO.lua JSON array written into their config_io resource.  You will either need to update each config_io resource manually from the devices page, or you will need to set  <code>set_to_device = false</code> in the configIO.lua file.  Setting that to false will allow auto-injection of the JSON in configIO.lua which will override the device-specific settings in each device's config_io resource.

---
## ToDo

It is probably possible to add two-way integration back into TTN to allow for functionality like new device creation, but that is a project for another day.

Did not implement Authorization header token checks - that should be simple to do by setting the token in TTN and going to the Settings sub page for your C2C Connector, go to the Environment Variables tab, and set the environment variable "callback_token" to the token you set in TTN.  This was not possible to test at current time due to environment variable settings page not yet available in Murano.

There is no payload validity checking - a malformed payload could be received and would be parsed and put into the data channels as bogus data.  

---

