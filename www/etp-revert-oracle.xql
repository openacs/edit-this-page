<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_revision">
<querytext>
begin
  content_revision.del(:revision_id);
end;
</querytext>
</fullquery>

<fullquery name="get_item_id">
<querytext>
  select item_id
    from cr_items
   where parent_id = etp.get_folder_id(:package_id)
     and name = :name
</querytext>
</fullquery>
 
<fullquery name="get_revision_count">
<querytext>
    select count(1) as revision_count
    from cr_revisions r, cr_items i
    where r.item_id = i.item_id
    and i.parent_id = etp.get_folder_id(:package_id)
    and i.name = :name
    and r.revision_id > :revision_id
</querytext>
</fullquery>
 
</queryset>
