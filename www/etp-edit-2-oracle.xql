<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_new_revision">
<querytext>
begin
  :1 := etp.create_new_revision(:package_id, :name, :user_id);
end;
</querytext>
</fullquery>
 
<fullquery name="update_content_attribute_clob">
<querytext>
    update cr_revisions
    set    content = empty_blob()
    where  revision_id = :latest_revision_id
    returning content into :1
</querytext>
</fullquery>
 
</queryset>
