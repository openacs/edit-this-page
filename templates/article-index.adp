<master src="../www/etp-master">
<property name="title">@pa.title;noquote@</property>
<property name="context">@pa.context;noquote@</property>

<if @pa.content@ not nil>
@pa.content;noquote@
</if>

<blockquote>

<multiple name="content_items">
<a href="@content_items.url@">@content_items.title@</a>
<if @content_items.description@ not nil>
 - @content_items.description@
</if>
<br><br>
</multiple>

</blockquote>
