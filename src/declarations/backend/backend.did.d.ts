import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Card { 'value' : string, 'suit' : string }
export interface _SERVICE {
  'getCards' : ActorMethod<[], Array<Card>>,
  'shuffleCards' : ActorMethod<[], undefined>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
