import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import '@testing-library/jest-dom'; 
import Button from './Button'; 

describe('Button Component', () => {
    test('renders the button with correct name and icon', () => {
        render(<Button name="Click Me" icon={<span>🚀</span>} />);
        
       
        expect(screen.getByText('Click Me')).toBeInTheDocument();
        
  
        expect(screen.getByText('🚀')).toBeInTheDocument();
    });

    test('applies the correct styles passed via props', () => {
        render(
            <Button 
                name="Styled Button" 
                bg="blue" 
                bPad="10px" 
                color="white" 
                bRad="5px" 
            />
        );

        const button = screen.getByText('Styled Button');

        // Check if the styles are applied
        expect(button).toHaveStyle({
            background: 'blue',
            padding: '10px',
            borderRadius: '5px',
            color: 'white',
        });
    });

    test('calls the onClick handler when clicked', () => {
        const onClickMock = jest.fn();
        render(<Button name="Click Me" onClick={onClickMock} />);

        const button = screen.getByText('Click Me');
        
        // Simulate a click
        fireEvent.click(button);

        // Check if the onClick handler was called
        expect(onClickMock).toHaveBeenCalledTimes(1);
    });

    test('renders with default styles when no props are provided', () => {
        render(<Button name="Default Button" />);
    
        const button = screen.getByText('Default Button');
    
        // Check if the button is rendered
        expect(button).toBeInTheDocument();
    
        // Adjust expected styles to match the browser or styled-components defaults
        expect(button).toHaveStyle({
            background: '', 
            color: 'ButtonText', 
            padding: '2px 6px 3px 6px',
            borderRadius: '',
        });
    });
    
});