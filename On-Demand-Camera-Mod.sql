/*
Name:       On Demand Camera Setting Modification
Purpose:    Bulk-modifies the On Demand option on all cameras on given servers
Author:     James Anderson
Date:       03Mar2020
Version:    1.1
Comments:   N/A

Version History:
 -  :    (01Mar2020)  1.0 Initial testing of code and assignment of column names
 -  :    (03Mar2020)  1.1 Added comments in-line with code to explain functionality of On Demand camera modification
*/

/*
This double-INNER-JOIN allows us to edit the On-Demand setting for cameras within the client's network video recorder (NVR) software, which utilizes a Microsoft SQL Server
database for managing recording servers, cameras, and configuration settings across relational tables.

For this client, they have physical servers located at remote sites as well as proxy servers that mirror the setup of the physical servers so anyone on the client's WAN
can access them.

The SELECT with the letter prefixes tells the SELECT statement to show MediaStreamsId and OnDemandCamera from the MediaStreams table, CameraName and CameraId from the Camera table,
and ServerId and DisplayName from the Server table.

We utilize two INNER JOIN clauses due to three different tables housing the information we need, the last - ServerId - being the most significant.
*/

/*
First, run this query to list the recording servers in your CompleteView 2020 setup so we may identify the ServerId value for which server(s) we want to make all cameras On Demand:
*/
SELECT *
FROM CompleteView.dbo.[Server]
/*
Next, we will take the ServerId values and include them in the following query in the WHERE statement (arbitrary values added for context)
*/
UPDATE MediaStreams
-- For On Demand box to be checked for TRUE for enablement, value MUST be 1!
SET OnDemandCamera = 1
FROM CompleteView.dbo.MediaStreams m
INNER JOIN CompleteView.dbo.Camera c ON c.CameraRelationId = m.CameraRelationId
INNER JOIN CompleteView.dbo.[Server] s ON s.ServerId = c.ServerId
WHERE s.ServerId IN (69,178,180,181,182,183)
-- We use the AND command to only include rows where the cameras are not deleted (a value of 0).
AND c.IsDeleted = 0
/*
Using the INNER JOIN from the UPDATE statement above, this allows us to verify that changes were successful.

To be successful, all cameras across the specified server IDs must now have an OnDemandCamera value of 1.
*/
SELECT m.MediaStreamsId, m.OnDemandCamera, c.CameraName, c.CameraId, s.ServerId, s.DisplayName
FROM CompleteView.dbo.MediaStreams m
INNER JOIN CompleteView.dbo.Camera c ON c.CameraRelationId = m.CameraRelationId
INNER JOIN CompleteView.dbo.[Server] s ON s.ServerId = c.ServerId
WHERE s.ServerId IN (69,178,180,181,182,183)
AND c.IsDeleted = 0