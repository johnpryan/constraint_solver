import 'package:checks/checks.dart';
import 'package:constraint_solver/constraint_solver.dart';
import 'package:test/test.dart';

class _Person {
  final String name;
  final List<String> dislikes;

  _Person(
    this.name, {
    this.dislikes = const [],
  });

  @override
  String toString() {
    return name;
  }
}

class _TestConstraint extends Constraint<_Person, String> {
  _TestConstraint(super.variables);

  @override
  bool isSatisfied(Map<_Person, String> assignment) {
    Set<String> assignedItems = {};
    for (var entry in assignment.entries) {
      var person = entry.key;
      var item = entry.value;

      if (person.dislikes.contains(item)) {
        return false;
      }
      assignedItems.add(item);
    }

    // Check that no duplicate items were assigned.
    if (assignedItems.length != assignment.length) {
      return false;
    }
    return true;
  }
}

void main() {
  group('constraint satisfaction framework', () {
    test('Satisfies constraints', () {
      var doug = _Person(
        'Doug',
        dislikes: ['hot dogs'],
      );
      var patrick = _Person(
        'Patrick',
        dislikes: ['cheese'],
      );
      var susan = _Person(
        'Susan',
        dislikes: ['bananas'],
      );

      var variables = [doug, patrick, susan];

      var items = [
        'cheese',
        'bananas',
        'hot dogs',
      ];

      var domains = {
        doug: items,
        patrick: items,
        susan: items,
      };

      var csp = CSP<_Person, String>(variables, domains);
      csp.addConstraint(_TestConstraint(variables));

      var result = csp.backtrackingSearch();

      check(result).isNotNull();
      result = result!;
      check(result[doug]).isNotNull();
      check(result[doug]).equals('cheese');
      check(result[patrick]).isNotNull();
      check(result[patrick]).equals('bananas');
      check(result[susan]).isNotNull();
      check(result[susan]).equals('hot dogs');
    });
  });
}
