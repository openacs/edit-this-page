<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_revision">
<querytext>
begin
  content_revision.delete(:revision_id);
end;
</querytext>
</fullquery>
 
</queryset>
