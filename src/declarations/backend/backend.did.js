export const idlFactory = ({ IDL }) => {
  const Card = IDL.Record({ 'value' : IDL.Text, 'suit' : IDL.Text });
  return IDL.Service({
    'getCards' : IDL.Func([], [IDL.Vec(Card)], ['query']),
    'shuffleCards' : IDL.Func([], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
