import { BaseRuleVisitor, ParserRule, getAttributes, getAttributeName, getTagName } from "@herb-tools/linter"

const LETTER = /\p{L}/u
const ENTITY = /&(?:#\d+|#x[\da-f]+|[a-z][a-z\d]*);/gi
const TRANSLATED_ATTRIBUTES = new Set(["placeholder", "title", "alt", "aria-label"])
const UNTRANSLATED_ELEMENTS = new Set(["script", "style"])

const hasLetter = (text) => LETTER.test(text.replace(ENTITY, ""))

// Reports text nodes, and placeholder/title/alt/aria-label values, that hold a letter outside ERB.
class LiteralTextVisitor extends BaseRuleVisitor {
  visitHTMLElementNode(node) {
    if (UNTRANSLATED_ELEMENTS.has(getTagName(node)?.toLowerCase())) return

    super.visitHTMLElementNode(node)
  }

  visitHTMLTextNode(node) {
    if (hasLetter(node.content)) {
      this.addOffense("Literal text in a template. Use a translation key: <%= t(\".key\") %>.", node.location)
    }

    super.visitHTMLTextNode(node)
  }

  visitHTMLOpenTagNode(node) {
    getAttributes(node).forEach((attribute) => this.checkAttribute(attribute))

    super.visitHTMLOpenTagNode(node)
  }

  checkAttribute(attribute) {
    if (!TRANSLATED_ATTRIBUTES.has(getAttributeName(attribute))) return

    const literal = (attribute.value?.children ?? [])
      .filter((child) => child.type === "AST_LITERAL_NODE")
      .map((child) => child.content)
      .join("")

    if (hasLetter(literal)) {
      this.addOffense("Literal attribute text. Use a translation key: <%= t(\".key\") %>.", attribute.location)
    }
  }
}

export default class LocaleNoLiteralTextRule extends ParserRule {
  static ruleName = "locale-no-literal-text"

  check(result, context) {
    const visitor = new LiteralTextVisitor(this.ruleName, context)
    visitor.visit(result.value)
    return visitor.offenses
  }
}
