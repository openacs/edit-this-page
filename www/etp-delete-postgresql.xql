<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_page">
<querytext>
select content_item__delete(:item_id);
</querytext>
</fullquery>

</queryset>
