<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_revision">
<querytext>

select content_revision__delete(:revision_id)

</querytext>
</fullquery>

</queryset>
