import Highlight from 'react-highlight'
import ToggleContent from 'Shared/ToggleContent'
import DocLink from 'Shared/DocLink/DocLink';

const NgRxDoc = (props) => {
  const { projectKey } = props;
  return (
    <div className="p-4">
      <div>This plugin allows you to capture NgRx actions/state and inspect them later on while replaying session recordings. This is very useful for understanding and fixing issues.</div>
      
      <div className="font-bold my-2">Installation</div>
      <Highlight className="js">
        {`npm i @openreplay/tracker-ngrx --save`}
      </Highlight>
      
      <div className="font-bold my-2">Usage</div>
      <p>Add the generated meta-reducer into your imports. See NgRx documentation for more details.</p>
      <div className="py-3" />

      <div className="font-bold my-2">Usage</div>
      <ToggleContent
        label="Server-Side-Rendered (SSR)?"
        first={
          <Highlight className="js">
        {`import { StoreModule } from '@ngrx/store';
import { reducers } from './reducers';
import OpenReplay from '@openreplay/tracker';
import trackerNgRx from '@openreplay/tracker-ngrx';
//...
const tracker = new OpenReplay({
  projectKey: '${projectKey}'
});
tracker.start();
//...
const metaReducers = [tracker.use(trackerNgRx(<options>))]; // check list of available options below
//...
@NgModule({
  imports: [StoreModule.forRoot(reducers, { metaReducers })]
})
export class AppModule {}`}
      </Highlight>
        }
        second={
          <Highlight className="js">
        {`import { StoreModule } from '@ngrx/store';
import { reducers } from './reducers';
import OpenReplay from '@openreplay/tracker/cjs';
import trackerNgRx from '@openreplay/tracker-ngrx/cjs';
//...
const tracker = new OpenReplay({
  projectKey: '${projectKey}'
});
//...
function SomeFunctionalComponent() {
  useEffect(() => { // or componentDidMount in case of Class approach
    tracker.start();
  }, [])
//...
const metaReducers = [tracker.use(trackerNgRx(<options>))]; // check list of available options below
//...
  @NgModule({
    imports: [StoreModule.forRoot(reducers, { metaReducers })]
  })
  export class AppModule {}
}`}
      </Highlight>
        }
      />

    <DocLink className="mt-4" label="Integrate NgRx" url="https://docs.openreplay.com/plugins/ngrx" />
    </div>
  )
};

NgRxDoc.displayName = "NgRxDoc";

export default NgRxDoc;
