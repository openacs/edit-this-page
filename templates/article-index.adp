<master src="../www/etp-master">
<property name="doc(title)">@pa.title;literal@</property>
<property name="context">@pa.context;literal@</property>

<if @pa.content@ not nil>
@pa.content;noquote@
</if>

<blockquote>

<multiple name="content_items">
<p><a href="@content_items.url@">@content_items.title@</a>
<if @content_items.description@ not nil>
 - @content_items.description@
</if>
<br><br>
</multiple>

</blockquote>
