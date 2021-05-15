import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import PrimeVue from 'primevue/config';
import Splitter from 'primevue/splitter';
import SplitterPanel from 'primevue/splitterpanel';
import Toolbar from 'primevue/toolbar';
import TabMenu from 'primevue/tabmenu';
import Button from 'primevue/button';
import Menu from 'primevue/menu';
import Fieldset from 'primevue/fieldset';
import Avatar from 'primevue/avatar';
import Editor from 'primevue/editor';
import InputText from 'primevue/inputtext';
import Tooltip from 'primevue/tooltip';
import DataView from 'primevue/dataview';
import { plugin } from '@inertiajs/inertia-vue3'


import 'primevue/resources/themes/vela-blue/theme.css';      //theme
import 'primevue/resources/primevue.min.css';                //core css
import 'primeflex/primeflex.css';
import "primeicons/primeicons.css";

createApp(App)
  .use(store)
  .use(router)
  .use(plugin)
  .use(PrimeVue)
  .component("Splitter", Splitter)
  .component( "SplitterPanel", SplitterPanel)
  .component("Toolbar", Toolbar)
  .component("TabMenu", TabMenu)
  .component("Button", Button)
  .component("Menu", Menu)
  .component("Fieldset", Fieldset)
  .component("Avatar", Avatar)
  .component("Editor", Editor)
  .component("InputText", InputText)
  .component("DataView", DataView)
  .directive("Tooltip", Tooltip)
  .mount("#app");
