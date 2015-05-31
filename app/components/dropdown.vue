<template>
    <span v-show="!is_editing">{{current.name}}</span>
    <span v-show=" is_editing">
        <select v-model="model">
            <option v-repeat="options" value="{{id}}">{{name}}</option>
        </select>
    </span>
</template>
<script>
module.exports = {
    inherit: true,
    data: function() {}
};
</script>
