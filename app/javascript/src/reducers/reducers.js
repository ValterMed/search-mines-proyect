import {combineReducers} from 'redux';
import gameReducer from './states';

const reducers = combineReducers({
  gameReducer: gameReducer
});

export default reducers;