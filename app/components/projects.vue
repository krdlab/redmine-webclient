<template>
    <div class="row">
        <div class="col-md-12">
            <div class="pull-right">
                <button type="button" class="btn btn-default" title="Reload projects">
                    <span class="glyphicon glyphicon-refresh"></span>
                </button>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table" v-repeat="projects">
                <thead>
                    <tr>
                        <th>名前</th>
                        <th>説明</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <a href="#/projects/{{id}}/issues">{{name}}</a>
                        </td>
                        <td>{{description}}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
<script>
var req = require('superagent');
module.exports = {
    inherit: true,
    created: function() {
        this.refresh_projects();
    },
    methods: {
        refresh_projects: function() {
            var app = this;
            // TODO: clear
            req
                .get(this.base_url + '/projects.json')
                .set('Accept', 'application/json')
                .end(function(err, res) {
                    if (err) {
                        console.log(err);
                    } else {
                        res.body.projects.forEach(function(p) {
                            app.projects.push(p);
                        });
                    }
                });
        }
    }
};
</script>
