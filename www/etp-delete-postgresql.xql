<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_page">
<querytext>
select content_item__delete(:item_id);
</querytext>
</fullquery>

<fullquery name="get_title">
<querytext>
  select title
    from cr_revisions r, cr_items i
   where i.parent_id = etp__get_folder_id(:package_id)
     and i.name = :name
     and r.item_id = i.item_id
     and r.revision_id = i.live_revision
</querytext>
</fullquery>

<fullquery name="get_item_id">
<querytext>
  select item_id
    from cr_items
   where parent_id = etp__get_folder_id(:package_id)
     and name = :name
</querytext>
</fullquery>

</queryset>
