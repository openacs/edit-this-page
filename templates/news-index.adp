<master src="../www/etp-master">
<property name="title">@pa.title@</property>
<property name="context_bar">@pa.context_bar@</property>

<if @pa.content@ not nil>
@pa.content@
</if>

<if @content_items:rowcount@ eq 0>
<em>There are no current news items</em>
</if>

<ul>

<multiple name="content_items">
<li>@content_items.release_date@: <a href="@content_items.url@">@content_items.title@</a>
</multiple>

</ul>

If you're looking for an old news article, check the <a href="?archive_p=t">expired news</a>.
