const greeter = (person: string) => {
    return `Hello, ${person}`;
}

function testGreeter() {
    const user = 'Bob';
    Logger.log(greeter(user));
    
}