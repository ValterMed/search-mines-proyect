import Styled from 'styled-components';
export const COVERED_COLOR = '#7f7e7e';
export const DISCOVERED_COLOR = '#c2bcbc';
export const BOMB_EXPLOSION_COLOR = '#ff0000';
export const Button = Styled.button`
  cursor: pointer;
  background: transparent;
  font-size: 18px;
  border-radius: 8px;
  color: #0023ff;
  border: 2px solid #0023ff;
  margin: 1px;
  padding: 8px;
  transition: 0.5s all ease-out;
  &:hover {
    background-color: #1cd1d1;
    color: white;
  }
  `;