<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_extlink">
<querytext>
    select etp.create_extlink(:package_id, :url, :label, :description);
</querytext>
</fullquery>
 
</queryset>
