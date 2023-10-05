R"""
"""
#
import torch
from typing import List, Tuple
from sklearn.metrics import roc_auc_score


#
CE = 0
ERR = 1
MACRO = 2


def loss(
    output: torch.Tensor, target: torch.Tensor, weight: torch.Tensor,
    /,
) -> torch.Tensor:
    R"""
    Loss function.
    """
    #
    if not (len(output.shape) == 2 and len(target.shape) == 1):
        # UNEXPECT:
        # Loss function must be computed on batched vectors.
        raise NotImplementedError(
            "Loss function must be computed on batched vectors.",
        )

    #
    return torch.nn.functional.cross_entropy(output, target, weight=weight)


def metrics(
    output: torch.Tensor, target: torch.Tensor, weight: torch.Tensor,
    /,
) -> List[Tuple[int, float]]:
    R"""
    All evaluation metrics.
    """
    #
    if not (len(output.shape) == 2 and len(target.shape) == 1):
        # UNEXPECT:
        # Loss function must be computed on batched vectors.
        raise NotImplementedError(
            "Loss function must be computed on batched vectors.",
        )

    #
    ce = (
        torch.nn.functional.cross_entropy(
            output, target,
            weight=weight, reduction="none",
        )
    )

    #
    score = torch.softmax(output, dim=1)
    pred = torch.argmax(score, dim=1)
    err = (pred != target).to(torch.float32)

    #
    try:
        #
        macro = (
            roc_auc_score(
                target.cpu().numpy(), score.cpu().numpy(),
                average="macro", multi_class="ovo",
            )
        )
    except:
        #
        macro = 0.0
    return [
        (len(ce), torch.sum(ce).item()),
        (len(err), torch.sum(err).item()),
        (1, -macro),
    ]