<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgres</type><version>7.1</version></rdbms>

<fullquery name="create_extlink">
<querytext>
    select etp__create_extlink(:package_id, :url, :label, :description);
</querytext>
</fullquery>
 
</queryset>
