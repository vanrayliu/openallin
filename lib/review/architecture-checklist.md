# Architecture Review Checklist

> Software architecture review checklist for maintainability, scalability, and soundness.

---

## SOLID Principles

### S — Single Responsibility Principle (SRP)

**Definition**: A class/module should have one reason to change.

**Checklist**:
- [ ] Each module has one responsibility
- [ ] Module name describes its responsibility
- [ ] Module has < 10 public methods (guideline)
- [ ] Module has < 300 lines of code (guideline)
- [ ] Changes to one responsibility don't affect others

**Common Violations**:
```javascript
// Bad: UserService does too much
class UserService {
  createUser() { /* user creation */ }
  sendEmail() { /* email sending */ }
  generateReport() { /* reporting */ }
  syncWithCRM() { /* CRM integration */ }
}

// Good: Separated responsibilities
class UserService {
  createUser() { /* user creation */ }
}

class EmailService {
  sendEmail() { /* email sending */ }
}

class ReportService {
  generateReport() { /* reporting */ }
}

class CRMService {
  syncWithCRM() { /* CRM integration */ }
}
```

---

### O — Open/Closed Principle (OCP)

**Definition**: Open for extension, closed for modification.

**Checklist**:
- [ ] New functionality added via extension
- [ ] Existing code not modified for new features
- [ ] Abstractions used for extension points
- [ ] Strategy pattern for varying behaviors

**Common Violations**:
```javascript
// Bad: Modifying existing code for new payment type
function processPayment(type, amount) {
  if (type === 'credit_card') {
    // process credit card
  } else if (type === 'paypal') {
    // process paypal
  } else if (type === 'stripe') {
    // NEW: had to modify existing function
  }
}

// Good: Extension via strategy pattern
const paymentStrategies = {
  credit_card: new CreditCardPayment(),
  paypal: new PayPalPayment(),
  stripe: new StripePayment(), // NEW: no modification
};

function processPayment(type, amount) {
  const strategy = paymentStrategies[type];
  return strategy.process(amount);
}
```

---

### L — Liskov Substitution Principle (LSP)

**Definition**: Subtypes must be substitutable for their base types.

**Checklist**:
- [ ] Subclasses can replace parent classes
- [ ] Subclasses don't violate parent contracts
- [ ] Subclasses don't throw unexpected exceptions
- [ ] Subclasses don't strengthen preconditions
- [ ] Subclasses don't weaken postconditions

**Common Violations**:
```javascript
// Bad: Square violates Rectangle contract
class Rectangle {
  setWidth(w) { this.width = w; }
  setHeight(h) { this.height = h; }
  getArea() { return this.width * this.height; }
}

class Square extends Rectangle {
  setWidth(w) { 
    this.width = w; 
    this.height = w; // Unexpected behavior!
  }
  setHeight(h) { 
    this.height = h; 
    this.width = h; // Unexpected behavior!
  }
}

// Good: Separate abstractions
class Shape {
  getArea() { throw new Error('Not implemented'); }
}

class Rectangle extends Shape {
  setWidth(w) { this.width = w; }
  setHeight(h) { this.height = h; }
  getArea() { return this.width * this.height; }
}

class Square extends Shape {
  setSize(s) { this.size = s; }
  getArea() { return this.size * this.size; }
}
```

---

### I — Interface Segregation Principle (ISP)

**Definition**: Clients shouldn't depend on interfaces they don't use.

**Checklist**:
- [ ] Interfaces are small and focused
- [ ] No "fat" interfaces
- [ ] Clients only implement methods they need
- [ ] Interface methods are cohesive

**Common Violations**:
```javascript
// Bad: Fat interface
interface Worker {
  work();
  eat();
  sleep();
}

class Robot implements Worker {
  work() { /* ok */ }
  eat() { throw new Error("Robots don't eat"); }
  sleep() { throw new Error("Robots don't sleep"); }
}

// Good: Segregated interfaces
interface Worker {
  work();
}

interface Eater {
  eat();
}

interface Sleeper {
  sleep();
}

class Robot implements Worker {
  work() { /* ok */ }
}

class Human implements Worker, Eater, Sleeper {
  work() { /* ok */ }
  eat() { /* ok */ }
  sleep() { /* ok */ }
}
```

---

### D — Dependency Inversion Principle (DIP)

**Definition**: Depend on abstractions, not concretions.

**Checklist**:
- [ ] High-level modules don't depend on low-level modules
- [ ] Both depend on abstractions
- [ ] Abstractions don't depend on details
- [ ] Details depend on abstractions
- [ ] Dependency injection used

**Common Violations**:
```javascript
// Bad: High-level module depends on low-level
class UserService {
  constructor() {
    this.db = new MySQLDatabase(); // tight coupling
    this.logger = new ConsoleLogger(); // tight coupling
  }
}

// Good: Depend on abstractions
class UserService {
  constructor(database, logger) {
    this.db = database; // injected dependency
    this.logger = logger; // injected dependency
  }
}

// Usage
const userService = new UserService(
  new MySQLDatabase(),
  new ConsoleLogger()
);
```

---

## Design Patterns

### Creational Patterns

#### Factory Pattern

**Use when**: Object creation logic is complex.

**Checklist**:
- [ ] Used when object creation varies
- [ ] Encapsulates object creation
- [ ] Client doesn't know concrete class

```javascript
// Factory Pattern
class PaymentFactory {
  static create(type) {
    switch (type) {
      case 'credit_card': return new CreditCardPayment();
      case 'paypal': return new PayPalPayment();
      default: throw new Error(`Unknown payment type: ${type}`);
    }
  }
}

const payment = PaymentFactory.create('credit_card');
```

---

#### Singleton Pattern

**Use when**: Only one instance needed.

**Checklist**:
- [ ] Only one instance exists
- [ ] Global access point provided
- [ ] Thread-safe (if applicable)
- [ ] Not overused (Singleton is often an anti-pattern)

```javascript
// Singleton Pattern
class Database {
  static instance;
  
  constructor() {
    if (Database.instance) {
      return Database.instance;
    }
    Database.instance = this;
  }
}

const db1 = new Database();
const db2 = new Database();
console.log(db1 === db2); // true
```

---

### Structural Patterns

#### Adapter Pattern

**Use when**: Interface doesn't match expected interface.

**Checklist**:
- [ ] Used to integrate incompatible interfaces
- [ ] Wraps existing interface
- [ ] Doesn't modify existing code

```javascript
// Adapter Pattern
class OldAPI {
  getUser(id) { return { id, name: 'John' }; }
}

class NewAPI {
  getUser(id) { return new OldAPI().getUser(id); }
  getUserProfile(id) {
    const user = this.getUser(id);
    return { id: user.id, fullName: user.name };
  }
}
```

---

#### Decorator Pattern

**Use when**: Add behavior without modifying class.

**Checklist**:
- [ ] Used to extend functionality
- [ ] Follows Open/Closed Principle
- [ ] Multiple decorators can be combined

```javascript
// Decorator Pattern
class Coffee {
  cost() { return 5; }
}

class MilkDecorator {
  constructor(coffee) {
    this.coffee = coffee;
  }
  
  cost() {
    return this.coffee.cost() + 1;
  }
}

class SugarDecorator {
  constructor(coffee) {
    this.coffee = coffee;
  }
  
  cost() {
    return this.coffee.cost() + 0.5;
  }
}

let coffee = new Coffee();
coffee = new MilkDecorator(coffee);
coffee = new SugarDecorator(coffee);
console.log(coffee.cost()); // 6.5
```

---

### Behavioral Patterns

#### Observer Pattern

**Use when**: Notify multiple objects of state changes.

**Checklist**:
- [ ] Used for event systems
- [ ] Subject notifies observers
- [ ] Observers can subscribe/unsubscribe

```javascript
// Observer Pattern
class Subject {
  observers = [];
  
  subscribe(observer) {
    this.observers.push(observer);
  }
  
  notify(data) {
    this.observers.forEach(obs => obs.update(data));
  }
}

class Observer {
  update(data) {
    console.log('Received:', data);
  }
}
```

---

#### Strategy Pattern

**Use when**: Different algorithms for same task.

**Checklist**:
- [ ] Used when behavior varies
- [ ] Algorithms are interchangeable
- [ ] Client chooses strategy

```javascript
// Strategy Pattern
class PaymentContext {
  constructor(strategy) {
    this.strategy = strategy;
  }
  
  pay(amount) {
    return this.strategy.pay(amount);
  }
}

class CreditCardStrategy {
  pay(amount) { /* credit card logic */ }
}

class PayPalStrategy {
  pay(amount) { /* paypal logic */ }
}

const payment = new PaymentContext(new CreditCardStrategy());
payment.pay(100);
```

---

## Module Coupling

### Coupling Types (Best to Worst)

1. **Data Coupling** (Best): Modules share data
2. **Stamp Coupling**: Modules share data structure
3. **Control Coupling**: Module controls another
4. **Common Coupling**: Modules share global data
5. **Content Coupling** (Worst): Module accesses another's internals

**Checklist**:
- [ ] Data coupling preferred
- [ ] Avoid control coupling
- [ ] Avoid common coupling
- [ ] Never use content coupling
- [ ] Max 5 dependencies per module (guideline)

**Measuring Coupling**:
```javascript
// High coupling (bad)
class OrderService {
  constructor() {
    this.userService = new UserService();
    this.paymentService = new PaymentService();
    this.inventoryService = new InventoryService();
    this.shippingService = new ShippingService();
    this.taxService = new TaxService();
    this.discountService = new DiscountService();
    this.notificationService = new NotificationService();
    this.analyticsService = new AnalyticsService();
  }
}

// Low coupling (good)
class OrderService {
  constructor(dependencies) {
    // Inject only needed dependencies
    this.userService = dependencies.userService;
    this.paymentService = dependencies.paymentService;
  }
}
```

---

### Cohesion Types (Worst to Best)

1. **Coincidental Cohesion** (Worst): No relationship
2. **Logical Cohesion**: Logically related
3. **Temporal Cohesion**: Executed at same time
4. **Procedural Cohesion**: Executed in sequence
5. **Communicational Cohesion**: Share same data
6. **Sequential Cohesion**: Output of one is input to another
7. **Functional Cohesion** (Best): Single well-defined task

**Checklist**:
- [ ] Functional cohesion preferred
- [ ] Avoid coincidental cohesion
- [ ] Module elements are strongly related

**Measuring Cohesion**:
```javascript
// Low cohesion (bad)
class Utils {
  static validateEmail(email) { /* email validation */ }
  static formatDate(date) { /* date formatting */ }
  static calculateTax(amount) { /* tax calculation */ }
  static generateId() { /* ID generation */ }
}

// High cohesion (good)
class EmailValidator {
  static validate(email) { /* email validation */ }
  static isValidFormat(email) { /* format check */ }
  static isDomainValid(email) { /* domain check */ }
}
```

---

## Layered Architecture

### Common Layers

1. **Presentation Layer**: UI components, controllers
2. **Application Layer**: Use cases, application services
3. **Domain Layer**: Business logic, domain entities
4. **Infrastructure Layer**: Database, external services

**Checklist**:
- [ ] Clear layer separation
- [ ] Dependencies point downward only
- [ ] No layer bypassing
- [ ] Each layer has single responsibility

**Layered Architecture Example**:
```javascript
// Presentation Layer (Controller)
class UserController {
  constructor(userService) {
    this.userService = userService;
  }
  
  async getUser(req, res) {
    const user = await this.userService.getUser(req.params.id);
    res.json(user);
  }
}

// Application Layer (Service)
class UserService {
  constructor(userRepository, emailService) {
    this.userRepository = userRepository;
    this.emailService = emailService;
  }
  
  async createUser(data) {
    const user = await this.userRepository.create(data);
    await this.emailService.sendWelcomeEmail(user.email);
    return user;
  }
}

// Domain Layer (Entity)
class User {
  constructor(id, name, email) {
    this.id = id;
    this.name = name;
    this.email = email;
  }
  
  isValid() {
    return this.name && this.email;
  }
}

// Infrastructure Layer (Repository)
class UserRepository {
  constructor(db) {
    this.db = db;
  }
  
  async create(data) {
    const result = await this.db.query('INSERT INTO users...', data);
    return new User(result.id, result.name, result.email);
  }
}
```

---

## Error Handling

### Error Handling Strategies

1. **Fail Fast**: Validate early, fail early
2. **Graceful Degradation**: Continue with reduced functionality
3. **Circuit Breaker**: Stop calling failing service
4. **Retry with Backoff**: Retry with increasing delay

**Checklist**:
- [ ] Consistent error handling strategy
- [ ] Errors logged with context
- [ ] User-friendly error messages
- [ ] No swallowed exceptions
- [ ] Proper error propagation

**Error Handling Example**:
```javascript
// Good: Comprehensive error handling
class UserService {
  async getUser(id) {
    try {
      const user = await this.repository.findById(id);
      
      if (!user) {
        throw new NotFoundError(`User ${id} not found`);
      }
      
      return user;
    } catch (error) {
      if (error instanceof NotFoundError) {
        logger.warn(`User not found: ${id}`);
        throw error;
      } else {
        logger.error('Database error', { id, error: error.message });
        throw new InternalServerError('Failed to get user');
      }
    }
  }
}
```

---

## Dependency Management

### Dependency Checklist

- [ ] Dependencies are up-to-date
- [ ] No known vulnerabilities (npm audit)
- [ ] Dependencies are necessary
- [ ] No unused dependencies
- [ ] No duplicate dependencies
- [ ] Dependency versions pinned in production

**Dependency Audit**:
```bash
# Check for vulnerabilities
npm audit

# Check for outdated packages
npm outdated

# Check for unused dependencies
npx depcheck

# Update dependencies
npm update
```

---

## Scalability

### Scalability Checklist

- [ ] Stateless where possible
- [ ] Horizontal scaling supported
- [ ] Database queries optimized
- [ ] Caching implemented
- [ ] Rate limiting implemented
- [ ] Load balancing supported
- [ ] CDN used for static assets

**Scalability Patterns**:
```javascript
// Stateless design (good)
class UserService {
  async getUser(id) {
    // No shared state, can scale horizontally
    return await this.repository.findById(id);
  }
}

// Stateful design (bad for scaling)
class UserService {
  users = {}; // Shared state, can't scale horizontally
  
  getUser(id) {
    return this.users[id];
  }
}
```

---

## Performance

### Performance Checklist

- [ ] No N+1 queries
- [ ] Database indexes used
- [ ] Pagination implemented
- [ ] Lazy loading used
- [ ] Compression enabled
- [ ] CDN used for assets

**Performance Patterns**:
```javascript
// Bad: N+1 query
const users = await User.findAll();
for (const user of users) {
  user.orders = await Order.findByUserId(user.id); // N queries
}

// Good: Eager loading
const users = await User.findAll({
  include: [{ model: Order }] // 1 query with JOIN
});
```

---

## Testing

### Testing Checklist

- [ ] Unit tests for business logic
- [ ] Integration tests for APIs
- [ ] E2E tests for critical paths
- [ ] Test coverage >= 70%
- [ ] Tests are fast (< 5s for unit tests)
- [ ] Tests are independent

**Test Architecture**:
```
tests/
  unit/           # Fast, isolated tests
  integration/    # API tests with database
  e2e/            # Full user flow tests
  performance/    # Load tests
```

---

## Architecture Review Summary

| Category | Priority | Key Metrics |
|----------|----------|-------------|
| SOLID Principles | High | SRP, OCP, LSP, ISP, DIP compliance |
| Design Patterns | Medium | Appropriate pattern usage |
| Module Coupling | High | Max 5 dependencies per module |
| Layered Architecture | High | Clear layer separation |
| Error Handling | High | Consistent strategy |
| Dependency Management | Medium | No vulnerabilities |
| Scalability | Medium | Stateless preferred |
| Performance | Medium | No N+1 queries |
| Testing | High | >= 70% coverage |

---

## Common Architecture Issues

| Issue | Severity | Fix |
|-------|----------|-----|
| High module coupling | Major | Reduce dependencies, use DI |
| Low cohesion | Major | Split module by responsibility |
| No layer separation | Major | Implement layered architecture |
| No error handling | Major | Add try-catch, logging |
| N+1 queries | Medium | Use eager loading |
| No tests | Major | Add unit/integration tests |
| God class/module | Major | Split into smaller modules |
| Circular dependencies | Major | Refactor to remove cycles |

---

## Notes

- Architecture review is **not a replacement** for architectural decision records (ADRs)
- Use as design-time check, not runtime enforcement
- Combine with `/oa-review` for code-level review
- Run `/oa-security` for security-specific review
- Consider team experience when choosing patterns