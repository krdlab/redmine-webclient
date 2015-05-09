var Vue = require('vue');
var req = require('superagent');
var director = require('director');

(function() {
    var storage = window.localStorage;
    var storage_key = function(k) { return 'redmine-webclient.' + k; };
    var is_empty = function(s) { return s == null || s == ''; };

    var app = new Vue({
        el: '#app',
        data: {
            base_url: '',
            api_key: '',
            error_message: null,
            currentView: 'projects',
            projects: [],
            project_id: ''
        },
        computed: {
            is_valid: function() {
                return !is_empty(this.base_url) && !is_empty(this.api_key);
            }
        },
        created: function() {
            this.load_settings();
            if (!this.is_valid) {
                this.error_message = 'base url and API key are required';
            } else {
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
        },
        methods: {
            load_settings: function() {
                this.base_url = storage.getItem(storage_key('base_url'));
                this.api_key  = storage.getItem(storage_key('api_key'));
            },
            save_settings: function() {
                storage.setItem(storage_key('base_url'), this.base_url);
                storage.setItem(storage_key('api_key'), this.api_key);
            }
        }
    });

    var projects = function() { app.currentView = 'projects'; };
    var issues = function(pid) {
        app.project_id = pid;
        app.currentView = 'issues';
    };

    var routes = {
        '/projects': projects,
        '/projects/:projectId/issues': issues
    };
    var router = director.Router(routes);
    router.init();
})();
