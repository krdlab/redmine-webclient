<template>
    <nav class="navbar navbar-default navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed"
                        data-toggle="collapse"
                        data-target="#navbar"
                        aria-expanded="false"
                        aria-controls="navbar">
                    <span class="sr-only"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#"></a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <form class="navbar-form">
                            <div class="form-group">
                                <input
                                    type="text"
                                    class="form-control"
                                    id="input_base_url"
                                    placeholder="Base URL"
                                    v-model="base_url" />
                            </div>
                            <div class="form-group">
                                <input
                                    type="password"
                                    class="form-control"
                                    id="input_api_key"
                                    placeholder="API key"
                                    v-model="api_key" />
                            </div>
                            <button type="button" class="btn btn-primary" title="Save"
                                    v-on="click: save_settings">
                                <span class="glyphicon glyphicon-save"></span>
                            </button>
                        </form>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</template>
<script>
module.exports = {
    inherit: true
};
</script>
