<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_extlink">
<querytext>
  begin
    :1 := etp.create_extlink(:package_id, :url, :label, :description);
  end;
</querytext>
</fullquery>
 
</queryset>
