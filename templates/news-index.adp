<master src="../www/etp-master">
<property name="doc(title)">@pa.title;literal@</property>
<property name="context">@pa.context;literal@</property>

<if @pa.content@ not nil>
@pa.content;noquote@
<br>
<br>
</if>

<if @content_items:rowcount@ eq 0>
<em>There are no 
<if @archive_p;literal@ false>current</if><else>expired</else>
news items</em>
</if>

<ul>

<multiple name="content_items">
<li>@content_items.release_date@: <a href="@content_items.url@">@content_items.title@</a>
</multiple>

</ul>

<if @archive_p;literal@ false>
If you're looking for an old news article, check the <a href="?archive_p=t">expired news</a>.
</if>
<else>
Return to the <a href="?">current news items</a>.
</else>